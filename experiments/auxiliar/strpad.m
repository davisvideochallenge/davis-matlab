%STRPAD pads a string with any number of char either at the start or the
%end
    %
    % % To pad the string ABC with zeros ('0') at the front to make it 8
    % % characters long ('i.e. 00000ABC')
    %  strpad('ABC',8,'pre','0')
    %
    % % To pad the string Hello with zeros ('Q') at the end to make it 14
    % % characters long ('i.e. HelloQQQQQQQQQ')                        
    %  strpad('Hello',14,'post','Q')
    %
    % % To pad the String 101010 with ones ('1') so that it is 16 characters
    % % long (i.e. '1111111111101010'). Note by default padding is 'pre'
    %  strpad('101010',16)
    %
    % % Error cases:
    % % - Not passing in a string
    %
    % % Warning cases:
    % % - Not passing in the required number of character
    % %  -- Default: return the string passed in
    % % - Passing in a string which is longer than the character requested
    % %  -- Default: return the string passed in
    % % - Passing in more than 1 padding character
    % %  -- Default: is to pad with '0's
    
    
function stringReturn = strpad(stringPassed,totalChars,charPosition,fillChar)
if nargin == 0
    stringReturn = '';
    return;
end

if nargin<4
    fillChar = '0';
    if nargin<3
        charPosition='pre';
        if nargin<2
            warning('You must pass the required totalChars'); %#ok<WNTAG>
            stringReturn = stringPassed;
            return;
        end
    end
end

if length(stringPassed)>=totalChars
    warning('The string is already longer than the required pad value');     %#ok<WNTAG>
    return;
end
if size(fillChar,1) ~= 1 || size(fillChar,2) ~=1
    warning('The fill char pass is too large using 0 (zeros) instead');     %#ok<WNTAG>
    fillChar = '0';
end

% Go through from the current length to the desired length the required len
stringReturn = stringPassed;
for i=length(stringPassed)+1:totalChars
    if strcmp(charPosition,'pre')
        stringReturn = [fillChar,stringReturn];     %#ok<AGROW>
    elseif strcmp(charPosition,'post')
        stringReturn = [stringReturn,fillChar];     %#ok<AGROW>
    end
end

end