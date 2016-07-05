import std.stdio;
import std.numeric : Fft;
import std.complex;
import std.math : PI,cos;

class Dct{
  Fft fft;
  this(size_t size){
    fft = new Fft(size);
  }

  //fftつかって離散コサイン変換
  Complex!F[] dct(F = double, R)(R input){
    R tmpInput=input.dup;
    for(int i=0;i<input.length/2;i+=1){
      tmpInput[i]=input[i*2];
    }
    for(int i=0;i<input.length/2;i+=1){
      tmpInput[i+input.length/2]=input[input.length-i*2-1];
    }
    auto ret=fft.fft(tmpInput);
    int N=ret.length;
    foreach(k;0..ret.length){
      ret[k]*=expi(-1*PI*k/(2*N));
      ret[k].im=0;
    }
    return ret;
  }

  //fft使わない
  Complex!F[] dctNoFft(F = double, R)(R input){
    Complex!F[] ret;
    int N=input.length;
    foreach(k;0..N){
      Complex!F x=0;
      foreach(n;0..N){
        x+=input[n]*cos(PI*k*(n+0.5)/N);
      }
      ret~=x;
    }
    return ret;
  }

  //fft使って逆離散コサイン返還
  Complex!F[] inverseDct(F = double, R)(R input){
    int N=input.length;
    Complex!F[] ret=input.dup;
    ret[0].im=0.0;
    foreach(i;1..input.length){
      ret[i].im=-input[input.length-i].re;
    }
    foreach(k;0..ret.length){
      ret[k]*=expi(PI*k/(2.0*N));
    }

    ret=fft.inverseFft(ret);

    auto tmpRet=ret.dup;
    for(int i=0;i<tmpRet.length/2;i+=1){
      tmpRet[i*2]=ret[i];
    }
    for(int i=0;i<tmpRet.length/2;i+=1){
      tmpRet[tmpRet.length-i*2-1]=ret[i+ret.length/2];
    }

    return tmpRet;
  }

  //fft使わない
  Complex!F[] inverseDctNoFft(F = double, R)(R input){
    Complex!F[] ret;
    int N=input.length;
    foreach(k;0..N){
      Complex!F x=0;
      foreach(n;1..N){
        x+=+input[n]*cos(PI*n*(k+0.5)/N);
      }
      ret~=(x+input[0]/2)/4;
    }
    return ret;
  }
}
