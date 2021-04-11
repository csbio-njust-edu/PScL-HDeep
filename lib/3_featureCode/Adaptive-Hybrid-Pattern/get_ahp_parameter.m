function parameter = get_ahp_parameter(quantization_level)

% Calculate the thresholds parameters for AHP algorithm

parameter_local = zeros(quantization_level-1,1);
parameter_global = zeros(quantization_level-1,1);
for i = 1:quantization_level-1
    parameter_global(i) = 2^0.5*erfinv((2*i - quantization_level)/quantization_level);
    if i < quantization_level/2
        parameter_local(i) = 2^0.5 / 2 * log(2*i/quantization_level);
    elseif i > quantization_level/2
        parameter_local(i) = -2^0.5 / 2 * log((2*quantization_level-2*i)/quantization_level);
    end
end

parameter.parameter_local = parameter_local;
parameter.parameter_global = parameter_global;