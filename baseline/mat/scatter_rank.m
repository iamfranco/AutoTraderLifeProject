function scatter_rank(x,y,xlab,ylab,xname,yname,lim)
  figure()
  set(gcf, 'Position', [0, 500, 500, 500])
  scatter(x, y,'.');
  xlabel(xlab);
  ylabel(ylab);
  axis equal
  
  xlim([0,length(x)]); ylim([0,length(x)]);
  print('-depsc', strcat('../fig/rank/',xname,'_v_',yname,'.eps')); % can't use '-painters' option because too slow
  xlim([0, lim]); ylim([0, lim]);
  print('-depsc','-painters', strcat('../fig/rank/',xname,'_v_',yname,'_lim.eps')); % '-painters' option to force vector graphics
end