function [FVAL] = ImplicitStabilityAxesModel(X_dot, X, inputs)
FVAL = StabilityAxesModel(X, inputs) - X_dot;
end
