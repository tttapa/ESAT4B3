class FIRFilter {
  public:
    template <size_t B>
    FIRFilter(const float (&b)[B]) : b(b), lenB(B) {
      x = new float[lenB]();
      M_b = new float[2*lenB-1];
      for (uint8_t i = 0; i < 2*lenB-1; i++) {
        M_b[i] = b[(2*lenB - 1 - i)%lenB];
      } 
    }
    float filter(float value) {
      x[i_b] = value;
      float b_terms = 0;
      float *b_shift = &M_b[lenB - i_b - 1];
      for (uint8_t i = 0; i < lenB; i++) {
        b_terms += x[i] * b_shift[i];
      }
      i_b = (i_b + 1) % lenB;
      return b_terms;
    }
  private:
    const uint8_t lenB;
    const float *b;
    uint8_t i_b = 0;
    float *x;
    float *M_b;
};
