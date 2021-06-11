\name{compare_ests}
\alias{compare_ests}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
A robust approach to comparing estimates across estimators.}
\description{
A function for comparing estimates obtained via different estimators in `benchtestr`. Produces a single df that can be plotted for quick summary visualization.
}
\usage{
compar_ests = function(dim, lm, match, df_exp, df_base, treatment, outcome, covars, formula_arg, reg_formula)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dim}{
     A toggle (1 == Yes) for including the Difference in Means (DIM) estimator.
}
  \item{lm}{
     A toggle (1 == Yes) for including the linear regression estimator.
}
  \item{match}{
     A toggle (1 == Yes) for including all four matching estimators. See documentation for `match_estimator` function for more information on the defaults.
}
  \item{df_exp}{
     The experimental dataset to be benchmarked. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable, but should ideally also have some covariates.
}
  \item{df_base}{
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
  Use this function to systematically compare across estimators. The output is a dataframe, which can be easily analyzed via quick visual inspection, additional programming, and/or plotting.
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
