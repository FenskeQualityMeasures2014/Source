function x = QuadDepthCorrect(s,t,u,v,z,lightfield,rgb,focus,su_ratio,deltaU,focus_LF)
h_uv = 1;
h_st = 1;
x = 0;
pix_offset =  480*deltaU/(2*focus_LF*tand(75/2));
pix_offset = 0;
epsilon = .0000001;
if ((s-floor(s)) == 0) s = s+epsilon; end
if ((t-floor(t)) == 0) t = t+epsilon; end
%For each of four s,t
u_p = u - (s - floor(s))*(focus_LF-z)/z*su_ratio - pix_offset;
v_p = v - (t - floor(t))*(focus_LF-z)/z*su_ratio - pix_offset;
temp = insideLoop(u_p,v_p,floor(s),floor(t),lightfield,rgb);
interpWeight_st = (h_st - abs(floor(s) - s))*(h_st - abs(floor(t) - t))/(h_st^2);
%interpWeight_st = .5;
x = x + interpWeight_st*temp;
%
u_p = u + (s - ceil(s))*(focus_LF-z)/z*su_ratio + pix_offset;
v_p = v + (t - floor(t))*(focus_LF-z)/z*su_ratio - pix_offset;
temp = insideLoop(u_p,v_p,ceil(s),floor(t),lightfield,rgb);
interpWeight_st = (h_st - abs(ceil(s) - s))*(h_st - abs(floor(t) - t))/(h_st^2);
x = x + interpWeight_st*temp;
%
u_p = u + (s - floor(s))*(focus_LF-z)/z*su_ratio - pix_offset;
v_p = v + (t - ceil(t))*(focus_LF-z)/z*su_ratio + pix_offset;
temp = insideLoop(u_p,v_p,floor(s),ceil(t),lightfield,rgb);
interpWeight_st = (h_st - abs(floor(s) - s))*(h_st - abs(ceil(t) - t))/(h_st^2);
x = x + interpWeight_st*temp;
%
u_p = u - (s - ceil(s))*(focus_LF-z)/z*su_ratio;
v_p = v - (t - ceil(t))*(focus_LF-z)/z*su_ratio;
temp = insideLoop(u_p,v_p,ceil(s),ceil(t),lightfield,rgb);
interpWeight_st = (h_st - abs(ceil(s) - s))*(h_st - abs(ceil(t) - t))/(h_st^2);
%interpWeight_st = 1;
x = x + interpWeight_st*temp;
%
if isnan(x)
    breakpoint = 0;
end


function temp = insideLoop(u_p,v_p,s_near,t_near,lightfield,rgb)
h_uv = 1;
h_st = 1;
temp = 0;
%
interpWeight_uv = (h_uv - abs(floor(u_p) - u_p))*(h_uv - abs(floor(v_p) - v_p))/(h_uv^2);
temp = temp + interpWeight_uv*Lightfield(floor(u_p),floor(v_p),s_near,t_near,lightfield,rgb);
%
interpWeight_uv = (h_uv - abs(ceil(u_p) - u_p))*(h_uv - abs(floor(v_p) - v_p))/(h_uv^2);
temp = temp + interpWeight_uv*Lightfield(ceil(u_p),floor(v_p),s_near,t_near,lightfield,rgb);
%
interpWeight_uv = (h_uv - abs(floor(u_p) - u_p))*(h_uv - abs(ceil(v_p) - v_p))/(h_uv^2);
temp = temp + interpWeight_uv*Lightfield(floor(u_p),ceil(v_p),s_near,t_near,lightfield,rgb);
%
interpWeight_uv = (h_uv - abs(ceil(u_p) - u_p))*(h_uv - abs(ceil(v_p) - v_p))/(h_uv^2);
temp = temp + interpWeight_uv*Lightfield(ceil(u_p),ceil(v_p),s_near,t_near,lightfield,rgb);

function value = Lightfield(s,t,u,v,lightfield,rgb)
%Some stuff to help get values
%lightfield size is [9 9 480 640 3]
u = max(1,min(9,u));
v = max(1,min(9,v));
s = max(1,min(480,s));
t = max(1,min(640,t));
value = lightfield(u,v,s,t,rgb);