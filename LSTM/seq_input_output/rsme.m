function res = rsme(exp,pre)
   res = sqrt(mean((exp - pre).^2));
end