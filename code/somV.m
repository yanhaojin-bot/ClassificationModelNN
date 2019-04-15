function [] =  somV(sM)

% function for drawing coonection weights map
U = som_umat(sM);
Um = U(1:2:size(U,1),1:2:size(U,2));

subplot(2,2,1)
som_cplane(sM,Um(:));
title('Distance matrix')

subplot(2,2,2)
C = som_colorcode(sM,'rgb4');
som_cplane(sM,C);
title('Color code')
