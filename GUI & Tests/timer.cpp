#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <ctime>
#include <unistd.h>

#include <chrono>

class Timer
{
  public:
    Timer() : m_beg(clock_::now())
    {
    }
    void reset()
    {
        m_beg = clock_::now();
    }

    double elapsed() const
    {
        return std::chrono::duration_cast<std::chrono::milliseconds>(
                   clock_::now() - m_beg)
            .count();
    }

  private:
    typedef std::chrono::high_resolution_clock clock_;
    typedef std::chrono::duration<double, std::ratio<1>> second_;
    std::chrono::time_point<clock_> m_beg;
};

int main()
{
    Timer tmr;
    tmr.reset();
    for (int i = 0; i < 10; i++)
    {
        printf("CLOCKS_PER_SEC: %ld\r\n", CLOCKS_PER_SEC);
        double t = tmr.elapsed();
        tmr.reset();
        printf("%lf\r\n", t);

        usleep(2778);
    }
}