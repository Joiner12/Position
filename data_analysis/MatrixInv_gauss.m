function Xout = MatrixInv_gauss(X)
    [g_m, g_n] = size(X);
    if(g_m ~= g_n)
        Xout = [];
        return;
    end
    
    %判断行列式是否为0
    if(g_n == 2)
        detr = X(1, 1) * X(2, 2) - X(1, 2) * X(2, 1);
        if(abs(detr) < 0.000000000001)
            Xout = [];
            return;
        end
    elseif(g_n== 3)
        detr = X(1, 1) * X(2, 2) * X(3, 3) +...
			X(1, 2) * X(2, 3) * X(3, 1) +...
			X(1, 3) * X(2, 1) * X(3, 2) -...
			X(3, 1) * X(2, 2) * X(1, 3) -...
			X(3, 2) * X(2, 3) * X(1, 1) -...
			X(3, 3) * X(2, 1) * X(1, 2);
        if(abs(detr) < 0.000000000001)
            Xout = [];
            return;
        end
    elseif(g_n > 3)
        detr =  calDet(X);
        if(abs(detr) < 0.000000000001)
            Xout = [];
            return;
        end
    end
    Xout = Invutri(X);
    
   %用高斯若当消元法
   function [Uout] =  Invutri(U)
     [n, m] = size(U);
     for k = 1 : m
         %计算乘数
         for i = 1 : m
             if(i ~= k)
                 U(i, k) = -(U(i, k) / U(k, k));
             end
         end
         U(k, k) = 1 / U(k, k);
         %消元计算
         for i = 1 : m
             if(i ~= k)
                 for j = 1 : m
                     if(j ~= k)
                         U(i, j) =  U(i, j) +  U(k, j) *  U(i, k);
                     end
                 end
             end
         end
         %计算主行
         for j = 1 : m
             if(j ~= k)
                 U(k, j) = U(k, j) * U(k, k);
             end
         end
     end
     Uout = U;
   end

%求矩阵行列式
function det =  calDet(X)
    [X_m, X_n] = size(X);
    if(X_m ~= X_n)
        det = 0;
        return;
    end
    
    if(X_n == 1)
        det = X(1, 1);
        return;
    elseif(X_n == 2)
        det = X(1, 1) * X(2, 2) - X(1, 2) * X(2, 1);
        return;
    elseif(X_n== 3)
        det = X(1, 1) * X(2, 2) * X(3, 3) +...
			X(1, 2) * X(2, 3) * X(3, 1) +...
			X(1, 3) * X(2, 1) * X(3, 2) -...
			X(3, 1) * X(2, 2) * X(1, 3) -...
			X(3, 2) * X(2, 3) * X(1, 1) -...
			X(3, 3) * X(2, 1) * X(1, 2);
        return;
    end
    
    liner = 0;
    for k = 1 : X_n
        p = 1;
        tr = zeros(X_n - 1, X_n - 1);
        for i = 2 : X_n
            q = 1;
            for j = 1 : X_n
                if(j ~= k)
                    tr(p, q) = X(i, j);
                    q = q + 1;
                end
            end
            p = p + 1;
        end
        Xre = X(1, k) * ((-1) ^ k) * calDet(tr);
        liner = liner + Xre;
    end
    det = liner;
end 
end