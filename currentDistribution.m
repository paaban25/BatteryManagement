function [I1, I2, I3, I4] = calculateCurrents(I, soc1, soc2, soc3, soc4)
    if I > 0
        % Calculate the total SOC
        totalSOC = soc1 + soc2 + soc3 + soc4;
        
        % Calculate individual currents
        I1 = (soc1 / totalSOC) * I;
        I2 = (soc2 / totalSOC) * I;
        I3 = (soc3 / totalSOC) * I;
        I4 = (soc4 / totalSOC) * I;
    elseif I < 0
        % Calculate the reciprocals of the SOCs
        recSOC1 = 1 / soc1;
        recSOC2 = 1 / soc2;
        recSOC3 = 1 / soc3;
        recSOC4 = 1 / soc4;
        
        % Handle zero SOC values by setting their reciprocals to zero
        if soc1 == 0
            recSOC1 = 0;
        end
        if soc2 == 0
            recSOC2 = 0;
        end
        if soc3 == 0
            recSOC3 = 0;
        end
        if soc4 == 0
            recSOC4 = 0;
        end
        
        % Calculate the total reciprocal SOC
        totalRecSOC = recSOC1 + recSOC2 + recSOC3 + recSOC4;
        
        % Calculate individual currents
        I1 = (recSOC1 / totalRecSOC) * I;
        I2 = (recSOC2 / totalRecSOC) * I;
        I3 = (recSOC3 / totalRecSOC) * I;
        I4 = (recSOC4 / totalRecSOC) * I;
    else
        % If I is zero, all currents are zero
        I1 = 0;
        I2 = 0;
        I3 = 0;
        I4 = 0;
    end
end



% Example values
I = -10;
soc1 = 1;
soc2 = 2;
soc3 = 3;
soc4 = 4;

[I1, I2, I3, I4] = calculateCurrents(I, soc1, soc2, soc3, soc4);

disp(['I1: ', num2str(I1)]);
disp(['I2: ', num2str(I2)]);
disp(['I3: ', num2str(I3)]);
disp(['I4: ', num2str(I4)]);


% Example values-2
I = 10;
soc1 = 1;
soc2 = 2;
soc3 = 3;
soc4 = 4;

[I1, I2, I3, I4] = calculateCurrents(I, soc1, soc2, soc3, soc4);

disp(['I1: ', num2str(I1)]);
disp(['I2: ', num2str(I2)]);
disp(['I3: ', num2str(I3)]);
disp(['I4: ', num2str(I4)]);


% Example values-3
I = -10;
soc1 = 1;
soc2 = 0;
soc3 = 2;
soc4 = 3;

[I1, I2, I3, I4] = calculateCurrents(I, soc1, soc2, soc3, soc4);

disp(['I1: ', num2str(I1)]);
disp(['I2: ', num2str(I2)]);
disp(['I3: ', num2str(I3)]);
disp(['I4: ', num2str(I4)]);


