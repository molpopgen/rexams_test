all: quiz1.pdf quiz_solutions1.pdf

# Key points:
# 1. An "exam" is a list of Rmd files.
# 2. Each Rmd file contains exactly 1 question.
#    Randomization occurs at the level of the question.
# 3. Truly different exams are different make targets
#    with different lists of Rmd files.
# 4. To get the quiz and the solutions to match up:
#    * different targets, set the seed.
#      This is what I am doing here,
#      but it is redundant work.
#    * If you have both pdf made via the same target,
#      you have to call set.seed(...) in between
#      calls to exams2pdf.  That has nothing to do
#      w/the exams package.  It is just how random
#      number generation works.
# 5. There is no programmatic way of avoiding
#    making custom edits of the LaTeX template file.
#    I took theirs, copied it to bio97.tex and
#    edited according to my needs.
#

SOURCES:=bio97.tex \
		 question1.Rmd \
		 questionwithRcode.Rmd \
		 questionwithPythonCode.Rmd

VENV:=venv

# NOTE: this doesn't work.
# The first array will very often result in > 1
# exam of the same version.
# I think we need each quiz to be a different target,
# meaning we need to handle seeds better.
# We'll get better parallel builds, tho!
quiz1.pdf quiz2.pdf quiz3.pdf: $(SOURCES) $(VENV) intro.tex
	( \
		. venv/bin/activate; \
	Rscript -e "library(exams);set.seed(666);exams2nops(n=3, institution='UC Irvine', course='Bio 97', logo='fake.png', blank=0, intro='intro.tex', list('question1.Rmd', 'questionwithRcode.Rmd', 'questionwithPythonCode.Rmd'), dir='.',name='quiz')"; \
	)

quiz_solutions1.pdf quiz_solutions2.pdf quiz_solutions3.pdf: $(SOURCES) $(VENV)
	( \
		. venv/bin/activate; \
	Rscript -e "library(exams);set.seed(666);exams2pdf(n=3, c('question1.Rmd', 'questionwithRcode.Rmd', 'questionwithPythonCode.Rmd'), dir='.',name='quiz_solutions',template='solution')"; \
	)

clean:
	rm -rf quiz1.pdf quiz2.pdf quiz3.pdf *_solutions*.pdf $(VENV)

venv: requirements.txt
	rm -rf venv
	python3 -m venv venv
	( \
		. venv/bin/activate; \
		python -m pip install --upgrade pip wheel; \
		python -m pip install --no-cache -r requirements.txt; \
	)
