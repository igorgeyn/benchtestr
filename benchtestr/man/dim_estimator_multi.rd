\name{dim_estimator_multi}
\alias{dim_estimator_multi}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Visualize and/or output a dataframe summary of DIM esimates.}
\description{
When running a DIM estimator for multiple outcomes, this function allows the user to obtain well-formatted overviews of all DIM esimates. User chooses whether to look at a visual plot or to output a dataframe..
}
\usage{
dim_estimator_multi(df_exp, df_base, treatment, outcomes_list, plot, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df_exp}{
     The experimental dataset to be benchmarked. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable, but should ideally also have some covariates.
}
  \item{df_base}{
     The observational dataset to be used for benchmarking. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable; should match the experimental dataset along both of these variables (name, variable type, etc.). Should ideally also have covariates, which are identical to those found in the benchmarking dataset.
}
  \item{treatment}{
     The variable that indicates treatment assignment in both the experimental and the observational datasets. Should be identical in both datasets.
}
  \item{outcomes_list}{
     The list of variables for which you'd like to compare DIM estimates. Formatting is currently robust to lists of up to eight (8) outcome variables, which should all be on the same scale (and, ideally, of the same nature).
}
  \item{plot}{
     A binary variable indicating whether you would like to output a plot (plot = 1) or a dataframe (plot = 0).
}
}
\details{
  Use this function to compare DIM esimates between benchmark and experimental datasets across a number of outcome variables. The idea is to be able to inspect very quickly, whether by looking across a dataframe or a visual (box) plot.
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Igor Geyn
}
\note{
This is part of the benchtestr package that will enable users to benchmark experimental findings.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x)
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
