public class testA {
    testA() {
        //empty constructor
    }

    public int typeItest(int a, int b) {
        return a + b;
    }

    
    public int typeIItest(int x, int y) {
        return x + y;
    }

    public int typeIIItestA(int a, int b) {
        System.out.println("This line should not bother type III clone detection");
        return a * b;
    }
}
