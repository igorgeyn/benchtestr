\name{balance_assess}
\alias{balance_assess}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Assess balance on observed covariate balance in your benchmarking data.}
\description{
This function allows the user to try out a number of classical / common matching techniques (coarsened exact matching, nearest-neighbors, and full optimal matching) on their benchmarking data. It leverages the existing `MatchIt` package. It produces charts for quick visual inspection of covariate balance.
}
\usage{
balance_assess(df_exp, df_bench, treat, outcome, covars, formula_arg, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df_exp}{
     The experimental dataset to be benchmarked. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable, but should ideally also have some covariates.
}
  \item{df_bench}{
     The observational dataset to be used for benchmarking. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable; should match the experimental dataset along both of these variables (name, variable type, etc.). Should ideally also have covariates, which are identical to those found in the benchmarking dataset.
}
  \item{treat}{
     The variable that indicates treatment assignment in both the experimental and the observational datasets. Should be identical in both datasets.
}
  \item{outcome}{
     The variable that indicates the outcome of interest in both the experimental and the observational datasets. Should be identical in both datasets.
}
  \item{covars}{
     A vector indicating the variables that serve as the observed covariates in the two datasets. Should be identical in name, variable type, etc. between both datasets. If using a vector of multiple variables (as opposed to a single covariate variable), be sure to define prior to the `balance_assess` function call.
}
}
\details{
  Use this function to apply the `cem`, `full`, and `nearest` matching methods from `MatchIt` in a single, robust, and convenient framework. Produces plots for a quick visual matching inspection, and for further analysis and estimation in `benchtestr`.
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
