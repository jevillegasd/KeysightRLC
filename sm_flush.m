function sm_flush(fid)
    if isa(fid,'visa')||isa(fid,'gpib'), flushinput(fid);
    elseif isa(fid,'tcpclient'), flush(fid);
    elseif isa(fid,'sm_instrument'), sm_flush(fid.connection);
    end
end