template <size_t N> class RunningAverage {
    static_assert(N <= 64, "Error: average length can't be greater than 64.");
  public:
    uint16_t add(uint16_t value) {
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
    uint16_t previousValues[N];
    uint8_t index = 0;
    uint16_t sum = 0;
    uint8_t filled = 0;
};

