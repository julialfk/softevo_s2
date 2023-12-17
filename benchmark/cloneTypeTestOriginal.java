public class cloneTypeTestOriginal {
    cloneTypeTestOriginal() {
        // empty constructor
    }

    public int typeItest(int a, int b) {
        return a + b;
    }

    public int typeIItest(int x, int y) {
        return x + y;
    }

    public int typeIIItest(int a, int b) {
        System.out.println("This line should not bother type III clone detection");
        return a * b;
    }

    private void subsumptionTest() {
        x = 0;
        a = 1;
        b = 2;
        c = 3;
        w = 4;
    }

    // Subsequence test accomodated for m3 AST structure.
    private void subsequenceM3Test() {
        x = 0;
        if (d > 1) {
            y = 1;
            z = 2;
        } else {
            h = 3;
            z = 1;
            y = 2;
        }
    }
}
