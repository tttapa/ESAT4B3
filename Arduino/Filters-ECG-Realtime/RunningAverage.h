template <size_t N> class RunningAverage {
  public:
    float add(float value) {
      sum -= previousValues[index];
      previousValues[index] = value;
      sum += value;
      index++;
      index = index % N;
      if (filled < N)
        filled++;
      return sum / filled;
    }
  private:
    float previousValues[N];
    uint8_t index = 0;
    float sum = 0;
    uint8_t filled = 0;
};

