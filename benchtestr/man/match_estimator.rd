\name{match_estimator}
\alias{match_estimator}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Produce a matching-based estimator using coarsened exact matching, nearest-neighbors matching, and/or full optimal matching.}
\description{
This function accompanies the `balance_assess` function in this package (`benchtestr`). While `balance_assess` gives you an idea of covariate balance, `match_estimator` goes a step further to actually produce estimates based on matched data. Estimates for each matching technique (e.g., CEM, etc.) are output in a single dataframe to allow for inspection across matching techniques.
}
\usage{
match_estimator(df_exp, df_bench, treat, outcome, covars, formula_arg, reg_formula, ...)
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
  \item{formula_arg}{
     The formula to use for covariate balancing. This takes the form of something like `treatment_variable` ~ `covariate_A` + `covariate_B` and so on, for all relevant observed coviarates.
}
\item{reg_formula}{
     The formula to use for producing an estimate once the mathed data is created. This takes the form of something like `outcome_variable` ~ `treatment_variable`. Best practice is to avoid using covariates in this formula.
}
}
\details{
  Use this function to obtain regression-based estimates of treatment effects using matched data from several popular `MatchIt` matching approaches. Produces a single dataframe for comparison across matching techniques.
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
