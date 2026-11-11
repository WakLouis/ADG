#include <adg/grids.hpp>
#include <adg/radix_decay.hpp>
#include <adg/query_risk_controller.hpp>
#include <iomanip>
#include <iostream>
#include <sstream>

int main(int argc, char** argv) {
    using namespace prob_counting::decay;
    try {
        const std::size_t budget=(argc>1?std::stoull(argv[1]):768)*1024;
        const double tau=argc>2?std::stod(argv[2]):96817.6252924919;
        const auto grids=make_grids();
        const auto config=Config::choose(tau);
        const RadixTransfer codec(grids, config);
        const PhaseClock phase(config.quantum_us, tau);
        const auto shared=codec.bytes()+phase.table_bytes();
        if (budget<shared+8) throw std::invalid_argument("budget must cover shared tables and two buckets");
        const auto width=(budget-shared)/8;
        const std::uint64_t seed=15485863;
        Sketch sketch(width, grids, config, seed, 0);
        sketch.factorized=&codec; sketch.phase_clock=&phase;
        QueryRiskController controller(sketch, 2, false, 500000);
        std::uint64_t serial=0, next_period=controller.period_us;
        auto advance=[&](std::uint64_t now) {
            while (next_period<=now) {
                sketch.advance_to(next_period); controller.through(next_period);
                next_period+=controller.period_us;
            }
            sketch.advance_to(now);
        };
        std::cerr<<"buckets_per_row="<<width<<" shared_bytes="<<shared<<"\n";
        std::cout<<std::setprecision(15);
        std::string line;
        while (std::getline(std::cin, line)) {
            if (line.empty()) continue;
            std::istringstream input(line);
            std::string op; std::uint64_t key, now;
            if (!(input>>op>>key>>now)) throw std::invalid_argument("expected: update|query KEY TIME_US");
            advance(now);
            if (op=="update") {
                controller.observe(key, now, ++serial);
                sketch.update(key, now, std::uint16_t(prob_counting::mix64(seed+UINT64_C(0x9e3779b97f4a7c15)*serial)));
            } else if (op=="query") std::cout<<key<<','<<now<<','<<sketch.query(key, now)<<'\n';
            else throw std::invalid_argument("expected update or query");
        }
    } catch (const std::exception& error) {
        std::cerr<<error.what()<<'\n'; return 1;
    }
}
