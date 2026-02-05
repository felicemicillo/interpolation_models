function [C] = bspline_deboor_fun(n, t, P)
%{
    L'algoritmo di de Boor è un metodo comune per valutare le curve 
    B-spline.
    Le curve B-spline sono definite da un insieme di punti di controllo che 
    determinano la loro forma.
    L'algoritmo consente di calcolare il valore di una curva B-spline in
    un punto specifico utilizzando la "ricorsione" per ottenere tale 
    valore.

   |-----------------------------------------------------------------------
    L'algoritmo può essere sintetizzato nei seguenti punti:

    1)  Dato un insieme di punti di controllo e un vettore di nodi, 
        che specifica il dominio parametrico della curva, 
        si determina l'intervallo in cui cade il punto desiderato.
        L'intervallo è definito dai nodi consecutivi che contengono il 
        punto.

    2)  Inizialmente, si considerano solo i punti di controllo che 
        corrispondono all'intervallo determinato nel passaggio precedente. 
        Questi punti sono detti "punti attivi".
    
    3) Ripetere i passaggi successivi fino a quando non si raggiunge un 
       singolo punto attivo:
        a. Per ogni punto attivo, calcolare il suo nuovo valore 
           interpolando tra i due punti attivi successivi nell'intervallo.
        b. Ridurre l'intervallo spostandosi verso destra di un nodo e 
           aggiornare i punti attivi di conseguenza.
    
    4) Il valore finale della curva B-spline nel punto desiderato è dato 
       dal singolo punto attivo rimanente dopo il passaggio precedente.

   |-----------------------------------------------------------------------
     -Argomenti in Input:
       n: 
         Ordine della B-Spline (2 per la lineare, 3 per la quadratica, 4
         per la cubica ecc.
       t:
         Vettore dei nodi (knot vector)
       P:
         Matrice dei punti di controllo
    
     -Argomenti in Output:
      C:
         Punti della curva B-Spline
   |-----------------------------------------------------------------------

    Questa funzione è stata utilizzata nel file 'bspline_curve.m' e 
    nell'app UI.

%}

    % Fase di validazione dei parametri in ingresso
    validateattributes(n, {'numeric'}, {'positive','integer','scalar'});
    d = n-1;                                                               % Grado della B-Spline.
    validateattributes(t, {'numeric'}, {'real','vector'});                 % Il vettore dei nodi deve essere composto da numeri reali.
    assert(all(t(2:end) >= t(1:end-1)), ...
        'bspline:deboor:InvalidArgumentValue', ...
        'Il vettore dei nodi deve essere in ordine crescente.');
    validateattributes(P, {'numeric'}, {'real','2d'});                     % La matrice dei punti di controllo deve essere composto da numeri reali.
    nctrl = numel(t)-(d+1);                                                % Il numero dei punti di controllo deve essere uguale al numero di elementi
    assert(size(P,2) == nctrl, 'bspline:deboor:DimensionMismatch', ...     % del vettore t meno il grado inserito + 2.
        ['Numero dei punti di controllo scorretti, %d dati, %d ' ...
        'richiesti.'], size(P,2), nctrl);

    % Vettore U dove valutare la curva B-Spline
    U = linspace(t(d+1), t(end-d), 10*size(P,2));                          % Viene creato un vettore 'U' che rappresenta una sequenza di punti in cui valutare la curva B-Spline.
                                                                           % Questi punti sono distribuiti uniformemente tra il primo nodo e l'ultimo nodo.
    m = size(P,1);                                                          
    t = t(:).';                                                            
    U = U(:);
    S = sum(bsxfun(@eq, U, t), 2);                                         
    I = bspline_deboor_interval(U,t);                                      % L'indice I indica i punti di controllo che sono coinvolti nel calcolo della B-Spline ottenuto
                                                                           % tramite la funzione 'bspline_deboor_interval' (spiegazione sotto)

    Pk = zeros(m,d+1,d+1);
    a = zeros(d+1,d+1);
    C = zeros(size(P,1), numel(U));
    for j = 1:numel(U)                                                     % Ricorsione di de Boor
        u = U(j);
        s = S(j);
        ix = I(j);
        Pk(:) = 0;
        a(:) = 0;

        Pk(:, (ix-d):(ix-s), 1) = P(:, (ix-d):(ix-s));                      
        h = d - s;                                                          

        if h > 0
            for r = 1:h
                q = ix-1;
                for i = (q-d+r):(q-s)
                    a(i+1,r+1) = (u-t(i+1)) / (t(i+d-r+1+1)-t(i+1));
                    Pk(:,i+1,r+1) = (1-a(i+1,r+1)) * Pk(:,i,r) + ...
                        a(i+1,r+1) * Pk(:,i+1,r);
                end
            end
            C(:,j) = Pk(:,ix-s,d-s+1);
        elseif ix == numel(t)
            C(:,j) = P(:,end);
        else
            C(:,j) = P(:,ix-d);
        end
    end
end

function ix = bspline_deboor_interval(u,t)                                 % Questa funzione restituisce l'indice del nodo nel vettore dei nodi t che non è inferiore al valore u.
    i = bsxfun(@ge, u, t) & bsxfun(@lt, u, [t(2:end) 2*t(end)]);           % Se il nodo ha molteplicità maggiore di 1, viene restituito l'indice più alto.
    [row,col] = find(i);
    [row,ind] = sort(row);
    ix = col(ind);
end


