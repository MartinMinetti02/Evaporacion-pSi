function [vscale, ref_zero, sample_rate, v_rate] = ParametrosOsciloscopio(linea_ascii)
    %Actualizado 23/03/26

    % Extrae Vscale
    vscale_match = regexp(linea_ascii, '"Vscale":"([\d\.]+)([mun]?V)"', 'tokens');
    if isempty(vscale_match)
        error('No se encontró Vscale en la línea ASCII.');
    end
    vscale_val = str2double(vscale_match{1}{1});
    vscale_unit = vscale_match{1}{2};

    % Conversión de unidad
    switch vscale_unit
        case 'V', escala_v = 1;
        case 'mV', escala_v = 1e-3;
        case 'uV', escala_v = 1e-6;
        case 'nV', escala_v = 1e-9;
        otherwise, error(['Unidad desconocida de Vscale: ', vscale_unit]);
    end
    vscale = vscale_val * escala_v;

    % Extrae Reference_Zero
    ref_match = regexp(linea_ascii, '"Reference_Zero":"(-?\d+)"', 'tokens');
    if isempty(ref_match)
        error('No se encontró Reference_Zero en la línea ASCII.');
    end
    ref_zero = str2double(ref_match{1}{1});

    % Extrae Sample_Rate (formato como "(10KS/s)")
    sr_match = regexp(linea_ascii, '"Sample_Rate":"\(([\d\.]+)([KMGT]?S/s)\)"', 'tokens');
    if isempty(sr_match)
        warning('No se encontró Sample_Rate en la línea ASCII. Devolviendo NaN.');
        sample_rate = NaN;
    else
        sr_val = str2double(sr_match{1}{1});
        sr_unit = sr_match{1}{2};
    
        % Escalado según unidad
        if contains(sr_unit, 'TS'), escala_sr = 1e12;
        elseif contains(sr_unit, 'GS'), escala_sr = 1e9;
        elseif contains(sr_unit, 'MS'), escala_sr = 1e6;
        elseif contains(sr_unit, 'kS') || contains(sr_unit, 'KS'), escala_sr = 1e3;
        else, escala_sr = 1;
        end
    
        sample_rate = sr_val * escala_sr;
    end

    % Extrae Vrate
    vr_match = regexp(linea_ascii, '"Voltage_Rate":"([\d\.]+)([mun]?v)"', 'tokens');
    if isempty(vr_match)
        error('No se encontró Voltage_Rate en la línea ASCII.');
    end
    vr_val = str2double(vr_match{1}{1});
    vr_unit = vr_match{1}{2};

    % Conversión de unidad
    switch vr_unit
        case 'v', escala_vr = 1;
        case 'mv', escala_vr = 1e-3;
        case 'uv', escala_vr = 1e-6;
        case 'nv', escala_vr = 1e-9;
        otherwise, error(['Unidad desconocida de Vrate: ', vr_unit]);
    end
    v_rate = vr_val * escala_vr;
end

