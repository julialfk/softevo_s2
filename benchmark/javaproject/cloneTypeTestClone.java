public class cloneTypeTestClone {
    cloneTypeTestClone() {
        //empty constructor
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
        y=2;
        a=1;
        b=2;
        c=3;
        i=5;
    }

    // Subsequence test accomodated for m3 AST structure.
    private void subsequenceM3Test() {
        y=0;
        a=0;
        b=0;
        c=0;
        i=0;

        if(y == 0) {
            y = 2;
        }
        if(a == 0) {
            a = 1;
        }
        if(b == 0) {
            b = 2;
        }
        if(c == 0) {
            c = 3;
        }
        if(i == 0) {
            i = 5;
        }
    }
}
