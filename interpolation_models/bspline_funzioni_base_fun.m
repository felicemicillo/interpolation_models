function N = bspline_funzioni_base_fun(h,t,n)
%{
    Questa funzione ci permette di calcolare le funzioni di base della
    curva B-Spline a partire dal vettore dei nodi fornito in ingresso.

   |-----------------------------------------------------------------------
     -Argomenti in Input:
       h: 
         Grado della curva.
       t:
         Vettore dei nodi (knot vector).
       n:
         Numero dei punti di controllo.
    
     -Argomenti in Output:
      N:
         Matrice contenente le funzioni di base.
   |-----------------------------------------------------------------------
     
     Questa funzione è stata utilizzata nel file 'bspline_curve.m' e
     nell'app UI.
%}

Z= linspace( t(1), t(end), 10*n);                                          % Vettore di punti in cui viene calcolata la curva.
N=zeros(size(Z,2),n);                                                      % Inizializzazione del vettore bidimensionale che contiene le funzioni di base.
N_h=zeros(size(Z,2),size(t,2));                                            % Matrice di supporto al calcolo delle funzioni di base.

% Formula di ricorsione di Cox-De Boor.

for i=1:size(Z,2)                                                          
    z = Z(i);                                                              % La variabile z è il punto in cui viene calcolata la curva.
    
% Funzioni di base grado 0.
    for j=1:size(t,2)-1                                                    % Costrutto for per tutti i numeri di nodi-1 (l'ultimo nodo non avrà un valore successivo su cui costruire l'intervallo). 
        if z>=t(j)&&z<t(j+1)                                               % Se il punto del linespace è maggiore del j-esimo nodo e minore del j+1esimo.
            N_h(i,j) = 1;                                                  % Setta il valore ad 1 nella j-esima colonna della matrice di supporto.
        else
            N_h(i,j) = 0;                                                  % Altrimenti lo setta a 0.
        end
    end

    
% Funzioni di base di grado successivo.
    for k=2:h                                                              % Iterazione per i gradi successivi.
        for j=1:size(t,2)-k                                                
            if N_h(i,j)==0
                add1 = 0;
            else
                add1 = (((z-t(j))/(t(j+k-1)-t(j)))*N_h(i,j));
            end
            if N_h(i,j+1)==0
                add2 = 0;
            else
                add2 =(((t(j+k)-z)/(t(j+k)-t(j+1)))* N_h(i,j+1));
            end
            N_h(i,j)=add1+add2;
        end
    end
            
end
N = N_h(:,1:n);
end
