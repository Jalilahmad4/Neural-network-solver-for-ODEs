function E = Cost(f, x, a, A, p)

y = trialy(x, a, A, p);
Dy = Dtrialy(x, a, p);
F = feval(f,x,y);
E = sum((Dy - F).^2);