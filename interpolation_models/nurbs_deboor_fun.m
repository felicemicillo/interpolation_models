function [C] = nurbs_deboor_fun(n,t,P,w)
%{
Per il calcolo delle NURBS utilizziamo sempre l'algoritmo di DeBoor
utilizzato anche per il calcolo delle B-Spline.
Per poter utilizzare l'algoritmo di de Boor, è necessario trasformare i 
punti di controllo 2D, utilizzati per definire le B-spline, in punti di 
controllo a 3 dimensioni. Questa trasformazione avviene nel modo seguente:

Le prime due dimensioni dei punti di controllo a 3D corrispondono alle 
coordinate dei punti di controllo originali moltiplicate per il peso del 
punto di controllo stesso.
La terza dimensione rappresenta il peso del punto di controllo stesso.
Dopo aver applicato l'algoritmo di de Boor ai punti di controllo a 
3 dimensioni, si proiettano i risultati nuovamente in due dimensioni 
per ottenere le curve di NURBS.

In sintesi, la trasformazione dei punti di controllo a 3D 
incorpora i pesi dei punti di controllo e consente di utilizzare 
l'algoritmo di de Boor per calcolare le curve di NURBS, che 
sono rappresentate in due dimensioni.

|-----------------------------------------------------------------------
     -Argomenti in Input:
       n: 
         Grado della curva.
       t:
         Vettore dei nodi (knot vector).
       P:
         Matrice dei punti di controllo.
       w:
         Vettore dei pesi (dimensione uguale al numero dei punti di
         controllo)
    
     -Argomenti in Output:
      C:
         Curva delle NURBS
   |-----------------------------------------------------------------------
     
     Questa funzione è stata utilizzata nel file 'nurbs.m' e
     nell'app UI.
%}

w = transpose(w(:));
P = bsxfun(@times, P, w);
P = [P ; w];

[Y] = bspline_deboor_fun(n,t,P);

C = bsxfun(@rdivide, Y(1:end-1,:), Y(end,:));