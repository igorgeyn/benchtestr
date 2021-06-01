\name{lm_estimator}
\alias{lm_estimator}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Estimate a treatment effect using linear regression.}
\description{
This function allows for the estimation of a treatment effect using linear regression given some dataset, an outcome variable, and a treatment variable. In the context of benchmarking experiemental findings, the regression estimator regresses the outcome variable on the treatment variable; untreated units are drawn from observational data and used in an identical regression process.
}
\usage{
lm_estimator(df_exp, df_base, treatment, outcome, delete_vars = "id|source")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df_exp}{
     The experimental dataset to be benchmarked. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable.
}
  \item{df_base}{
     The observational dataset to be used for benchmarking. Format as a dataframe object in R. This should include at least an outcome variable and a treatment variable; should match the experimental dataset along both of these variables (name, variable type, etc.).
}
  \item{treatment}{
     The variable that indicates treatment assignment in both the experimental and the observational datasets. Should be identical in both datasets.
}
  \item{outcome}{
     The variable that indicates the outcome of interest in both the experimental and the observational datasets. Should be identical in both datasets.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
Shing Hon Lam
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
