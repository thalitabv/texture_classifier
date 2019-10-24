% extrai o total de classes e amostras
% consulta apenas atributos de uma banda
function [tclasses, tsamples] = extract_cl_samples(Feature)
A = Feature(1).structure;
tclasses = 0;
tsamples = 0;
nome = '';
if ~isempty(A)
    for i=1:size(A,2)
        if ~strcmp(nome,A(i).class)
            nome = A(i).class;
            tclasses = tclasses+1;
            B = A(i).roi;
            if ~isempty(B)
                for j=1:(size(B,2))
                    tsamples = tsamples+(size(B(j).patterns,1));
                end
            end
        end
    end
end
