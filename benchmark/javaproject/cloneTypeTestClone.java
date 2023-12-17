public class cloneTypeTestClone {
    cloneTypeTestClone() {
        // empty constructor
    }

    public int typeItest(int a, int b) {
        return a + b;
    }

    public int typeIItest(int num1, int num2) {
        return num1 + num2;
    }

    public int typeIIItest(int x, int y) {
        return x * y;
    }

    private void subsumptionTest() {
        y = 2;
        a = 1;
        b = 2;
        c = 3;
        i = 5;
    }

    // Subsequence test accomodated for m3 AST structure.
    private void subsequenceM3Test() {
        x = 0;
        if (d > 2) {
            y = 1;
            z = 2;
        } else {
            h = 3;
            z = 1;
            y = 2;
        }
    }
}
