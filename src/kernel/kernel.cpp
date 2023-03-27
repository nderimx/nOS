char *videomemorystart = (char *) 0xb8000;
char *videomemory = (char *) 0xb8000;
void print(char* text) {
    int i = 0;
    while (text[i] != 0) {
        *videomemory = text[i];
        videomemory += 2;
        i++;
    }
    return;
}
void backUpPrinter() {
    videomemory = videomemorystart;
    return;
}
extern "C" void main() {
    char* message = "Welcome to the C++ Kernel.";
    print(message);
    print("This should come next.");
    return;
}