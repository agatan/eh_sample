void exit(int);

void f() {
    try {
        throw 1;
    } catch (int x) {
        exit(x);
    } catch (double) {
        exit(10000);
    }
}
