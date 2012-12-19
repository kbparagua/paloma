Paloma.callbacks['articles/index'] = function(params){
  $('body').append($("<div id='article-count-" + params['article_count'] + "'></div>"));
};
