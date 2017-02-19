function [xpts,ypts,zpts]=interpEndpoints(xend,yend,zend,ninterp)
% [xpts,ypts,zpts]=interpEndpoints(xend,yend,zend,ninterp)
%
% Creates regularly spaced points between the x, y, and z endpoints
%
% INPUT:
%
% xend      Endpoints for the x-coordinate [x0 xend]
% yend      Endpoints for the y-coordinate [y0 yend]
% zend      Endpoints for the z-coordinate [z0 zend]
% ninterp   Number of points including both end points
%
% Last modified by plattner-at-alumni.ethz.ch, 1/10/2016

xpts=linspace(xend(1),xend(2),ninterp);
ypts=linspace(yend(1),yend(2),ninterp);
zpts=linspace(zend(1),zend(2),ninterp);
