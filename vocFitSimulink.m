function voc = vocFitSimulink(soc)

persistent aux;
if isempty(aux)
    aux = load('vocFitSimulink.mat','vocFit');
end
voc = feval(aux.vocFit,soc);
end