import std.stdio;
import std.numeric : Fft;
import std.complex;
import std.math : PI,cos;
import std.random;
import dct;
//import dfftw3.fftw3;


//サンプルコード
void main(){
    auto x = [1,2,1,0,2,3,1,3];
    auto fft = new Dct(32);
    auto fx = fft.dct(x); // それぞれを
    "fx : ".writeln(fx);
    auto z = fft.inverseDct(fx); // そして逆変換
    "z = ".writeln(z);
    // 小さな誤差があるが [1,3,3,1] が表示される。畳み込みの計算が成功している。
}
