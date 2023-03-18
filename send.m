function ret = send(g,cmd,varargin)
    sm_flush(g);
    if isempty(varargin)
         cmdc = char(cmd);
    else
         cmdc = char(sprintf(cmd,varargin{1:end}));
    end
   
    wait = 0;
    if ~isempty(find(abs(cmdc-63)<=10^-5,1)) %Test if there is an interrogation sign in the command
        wait = 1;
    end
    
    if isa(g,'tcpclient') 
        %Note that tcp/ip function in client mode will be removed from
        %matlab, hence it is recommended to use tcpclient instead.
        flush(g);
        writeline(g,cmdc); 
        if cmdc(end) == '?'|| wait, ret = readline(g);
        else, ret = '';
        end  
    elseif isa(g,'gpib')||isa(g,'visa')
        close = 0;
        if (strcmp(g.status,'closed'))
            close = 1;
            fopen(g);
        end
        
        fprintf(g,cmdc); 
        if cmdc(end) == '?'|| wait, ret = fscanf(g);
        else, ret = '';
        end
        
        if close, fclose(g); end
    elseif isa(g,'sm_instrument')
         ret = send(g.connection,cmdc);
    elseif isa(g,'tcpip')
        %fopen(g);
        fwrite(g, cmdc)
        if (cmdc(end) == '?'|| wait) && g.BytesAvailable>0
            ret = fread(t, t.BytesAvailable);   
        else, ret = '';
        end  
        %fopen(g);
    else
        if isempty(g)
            ME = MException('SpectralM:InterfaceNotsent', ...
            'No interface specified.');
        else
            ME = MException('SpectralM:InterfaceNotIdentified', ...
            'Cannot send data using %s instrument type ',g.connection);
        end
        throw(ME);
    end
    
end