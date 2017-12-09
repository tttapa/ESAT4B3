// #define USE_MODULO
class IIRFilter {
  public:
    template <size_t B, size_t A>
    IIRFilter(const float (&b)[B], const float (&_a)[A]) : b(b), a0(_a[0]), a(&_a[1]), lenB(B), lenA(A-1) {
      x = new float[lenB]();
      y = new float[lenA]();
      M_b = new float[2*lenB-1];
      M_a = new float[2*lenA-1];
      for (uint8_t i = 0; i < 2*lenB-1; i++) {
        M_b[i] = b[(2*lenB - 1 - i)%lenB];
      }
      for (uint8_t i = 0; i < 2*lenA-1; i++) {
        M_a[i] = a[(2*lenA - 2 - i)%lenA];
      }
    }
    float filter(float value) {
      x[i_b] = value;
      float b_terms = 0;
      float *b_shift = &M_b[lenB - i_b - 1];
      for (uint8_t i = 0; i < lenB; i++) {
        b_terms += x[i] * b_shift[i];
      }
      float a_terms = 0;
      float *a_shift = &M_a[lenA - i_a - 1];
      for (uint8_t i = 0; i < lenA; i++) {
        a_terms += y[i] * a_shift[i];
      }
      float filtered = (b_terms - a_terms) / a0;
      y[i_a] = filtered;
      // 17.35% CPU (division is slow)
      /*i_b = (i_b + 1) % lenB;
      i_a = (i_a + 1) % lenA;*/
      // 15.41% CPU
      i_b++;
      if(i_b == lenB)
        i_b = 0;
      i_a++;
      if(i_a == lenA)
        i_a = 0;
      return filtered;
    }
  private:
    const uint8_t lenB, lenA;
    const float *b;
    const float *a;
    const float a0;
    uint8_t i_b = 0, i_a = 0;
    float *x;
    float *y;
    float *M_b;
    float *M_a;
};
