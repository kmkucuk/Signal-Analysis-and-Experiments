function cpalette=callpalette(x)

palette1={hex2rgb('#E1D89F'),hex2rgb('#D89216'),hex2rgb('#374045'),hex2rgb('#2C061F')};
palette2={hex2rgb('#F6C065').*.8,hex2rgb('#55B3B1'),hex2rgb('#AF0069'),hex2rgb('#09015F')};
palette3={hex2rgb('#121013'),hex2rgb('#4D375D'),hex2rgb('#EB596E'),hex2rgb('#FFE227')};
palette4={[1 1 1],[1 1 1]};
    if x == 1
        cpalette=palette1;
    elseif x==2
        cpalette=palette2;
    elseif x==3
        cpalette=palette3;
    elseif x==4
        cpalette=palette4;
    end

end
