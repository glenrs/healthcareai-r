% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tune_models.R
\name{tune_models}
\alias{tune_models}
\title{Tune multiple machine learning models using cross validation to optimize
performance}
\usage{
tune_models(d, outcome, models, metric, positive_class, n_folds = 5,
  tune_depth = 10, hyperparameters = NULL, model_class)
}
\arguments{
\item{d}{A data frame}

\item{outcome}{Name of the column to predict}

\item{models}{Names of models to try, by default "rf" for random forest and
"knn" for k-nearest neighbors. See \code{\link{supported_models}} for
available models.}

\item{metric}{What metric to use to assess model performance? Options for
regression: "RMSE" (root-mean-squared error, default), "MAE" (mean-absolute
error), or "Rsquared." For classification: "ROC" (area under the receiver
operating characteristic curve), or "PR" (area under the precision-recall
curve).}

\item{positive_class}{For classification only, which outcome level is the
"yes" case, i.e. should be associated with high probabilities? Defaults to
"Y" or "yes" if present, otherwise is the first level of the outcome
variable (first alphabetically if the training data outcome was not already
a factor).}

\item{n_folds}{How many folds to use in cross-validation? Default = 5.}

\item{tune_depth}{How many hyperparameter combinations to try? Defualt = 10.}

\item{hyperparameters}{Optional, a list of data frames containing
hyperparameter values to tune over. If NULL (default) a random,
\code{tune_depth}-deep search of the hyperparameter space will be
performed. If provided, this overrides tune_depth. Should be a named list
of data frames where the names of the list correspond to models (e.g. "rf")
and each column in the data frame contains hyperparameter values. See
\code{\link{hyperparameters}} for a template. If only one model is
specified to the \code{models} argument, the data frame can be provided
bare to this argument.}

\item{model_class}{"regression" or "classification". If not provided, this
will be determined by the class of `outcome` with the determination
displayed in a message.}
}
\value{
A model_list object. You can call \code{plot}, \code{summary},
  \code{evaluate}, or \code{predict} on a model_list.
}
\description{
Tune multiple machine learning models using cross validation to optimize
performance
}
\details{
Note that this function is training a lot of models (100 by default)
  and so can take a while to execute. In general a model is trained for each
  hyperparameter combination in each fold for each model, so run time is a
  function of length(models) x n_folds x tune_depth. At the default settings,
  a 1000 row, 10 column data frame should complete in about 30 seconds on a
  good laptop.
}
\examples{
\dontrun{
### Examples take about 30 seconds to run
# Prepare data for tuning
d <- prep_data(pima_diabetes, patient_id, outcome = diabetes)

# Tune random forest and k-nearest neighbors classification models
m <- tune_models(d, outcome = diabetes)

# Get some info about the tuned models
m

# Get more detailed info
summary(m)

# Plot performance over hyperparameter values for each algorithm
plot(m)

# To specify hyperparameter values to tune over, pass a data frame
# of hyperparameter values to the hyperparameters argument:
rf_hyperparameters <-
  expand.grid(
    mtry = 1:5,
    splitrule = c("gini", "extratrees"),
    min.node.size = 1
  )
grid_search_models <-
  tune_models(d = d,
              outcome = diabetes,
              models = "rf",
              hyperparameters = list(rf = rf_hyperparameters)
  )
plot(grid_search_models)
}
}
\seealso{
For setting up model training: \code{\link{prep_data}},
  \code{\link{supported_models}}, \code{\link{hyperparameters}}

  For evaluating models: \code{\link{plot.model_list}},
  \code{\link{evaluate.model_list}}

  For making predictions: \code{\link{predict.model_list}}

  For faster, but not-optimized model training: \code{\link{flash_models}}

  To prepare data and tune models in a single step: \code{\link{machine_learn}}
}
