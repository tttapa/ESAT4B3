#ifndef RUNNINGAVERAGE_H
#define RUNNINGAVERAGE_H

template <typename T, size_t N> class RunningAverage {
  public:
    float add(T value) {
      sum -= previousValues[index];
      previousValues[index] = value;
      sum += value;
      index++;
      if (index == N)
        index = 0;
      if (filled < N)
        filled++;
      return sum / filled;
    }
  private:
    T previousValues[N];
    uint8_t index = 0;
    T sum = 0;
    uint8_t filled = 0;
};

#endif
