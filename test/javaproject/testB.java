public class testB {
    testB() {
        //empty constructor
    }

    public int typeItest(int a, int b) {
        return a + b;
    }
    
    public int typeIItest(int num1, int num2) {
        return num1 + num2;
    }
    
    public int typeIIItestA(int x, int y) {
        return x * y;
    }

    public int typeIIItestB(int a, int b) {
        System.out.println("This line should not bother type III clone detection");
        return a * b;
    }
}
