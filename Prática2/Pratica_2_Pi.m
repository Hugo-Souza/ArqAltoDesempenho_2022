format long
clear
clc

function aux = leibniz_serial(N)
  result = 0;
  sinal = 1;
  tic;
  for i = 0:(N-1)
      result += sinal/(2*i+1);
      sinal *= -1;
  endfor
  result *= 4;
  tempo = toc;
  erro = pi - result;
  aux = [result, erro, tempo];
endfunction
function aux = leibniz_paralelo(N)
  vector_index = 0:N-1;
  vector_signal = (-1).^vector_index;
  vector_den = 1:2:(2*N);
  tic;
  result = 4*sum(vector_signal./vector_den);
  tempo = toc;
  erro = pi - result;
  aux = [result, erro, tempo];
endfunction

function aux = mc_serial(n)
  result = 0;
  tic;
  for i = 1:n
    x = rand();
    y = rand();
    if(x^2 + y^2 <=1)
      result++;
    endif
  endfor
  result = 4*result/n;
  tempo = toc;
  erro = pi - result;
  aux = [result, erro, tempo];
endfunction
function aux = mc_parallel(n)
  fun = @(x,y) x.^2+y.^2 <=1;
  vector_x = rand(1, n);
  vector_y = rand(1, n);
  tic;
  result = sum(fun(vector_x, vector_y));
  result = 4*result/n;
  tempo = toc;
  erro = pi - result;
  aux = [result, erro, tempo];
endfunction

teste = [1000, 50000, 200000, 500000, 50000000];

for i = 1 : columns(teste)
  printf("Teste com %d pontos\n", teste(i));
  result_serial_mc = mc_serial(teste(i));
  result_paralelo_mc = mc_parallel(teste(i));
  result_serial_leibniz = leibniz_serial(teste(i));
  result_paralelo_leibniz = leibniz_paralelo(teste(i));

  printf("Resultado para o teste serial monte carlo: valor=%f erro=%f tempo=%f\n", result_serial_mc(1), result_serial_mc(2), result_serial_mc(3));
  printf("Resultado para o teste paralelo monte carlo: valor=%f erro=%f tempo=%f\n", result_paralelo_mc(1), result_paralelo_mc(2), result_paralelo_mc(3));
  printf("Resultado para o teste serial leibniz: valor=%f erro=%f tempo=%f\n", result_serial_leibniz(1), result_serial_leibniz(2), result_serial_leibniz(3));
  printf("Resultado para o teste paralelo leibniz: valor=%f erro=%f tempo=%f\n", result_paralelo_leibniz(1), result_paralelo_leibniz(2), result_paralelo_leibniz(3));

  speedup_mc = result_serial_mc(3)/result_paralelo_mc(3);
  speedup_leibniz = result_serial_leibniz(3)/result_paralelo_leibniz(3);

  printf("O speedup do teste com %d pontos no método de monte carlo é: %f\n", teste(i), speedup_mc);
  printf("O speedup do teste com %d pontos no método de leibniz é: %f\n", teste(i), speedup_leibniz);
endfor
