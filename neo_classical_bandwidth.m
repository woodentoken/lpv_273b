function [w_BC] = neo_classical_bandwidth(S,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

upper = 1+alpha;
lower = 1-alpha;

[mag, ~, w] = bode(S);

isBounded = or(mag>upper, mag<lower)
index_bc = find(isBounded, 1, 'last');
w_BC = w(index_bc);
end