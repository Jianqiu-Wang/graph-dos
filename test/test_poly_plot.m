% Load one of the Gleich examples
A = load_graph('gleich', 'pgp-cc');

% Apply a filter
N = matrix_normalize(A);
c = filter_jackson(moments_delta(0.5, 500));
c(1) = c(1)/2;
pN = mfunc_cheb_poly(c,N);

% Pull out representative vectors (should revisit)
nprobe = 200;
thresh = 1e-3;
Z = randn(length(N),nprobe);
AZ = pN(Z);

% Version 0: Eigenvector computation
[V,D] = eig_rand1(Z, AZ, thresh);
[lambda,I] = sort(diag(D), 'descend');
V = V(:,I);
if length(D) == nprobe
  warning('Did not converge to desired threshold\n');
end


% Sort out and select top group by leverage on the subspace
nmode = sum(lambda > 0.95*lambda(1));
score = sum(V(:,1:nmode).^2, 2);
[sscore,I] = sort(score, 'descend');
I = I(1:400);

% Plot top group
figure;
As = A(I,I);
gplot_shatter(As,4);


% Alternative: Heuristic sparsification
marks = zeros(length(N),1);
nmode = sum(lambda > 0.95*lambda(1));
[Q,R,E] = qr(V',0);
VQ = V*Q';
[~,I] = sort(max(abs(VQ(:,j)),[],2), 'descend');
I = I(1:400);
figure;
gplot_shatter(A(I,I),4);
