function y = Dtrialy(x, a, p)
   y = Net(x, p) + (x - a).*dNet(x, p);