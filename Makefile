all: quiz1.pdf quiz1_solutions.pdf

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

quiz1.pdf: $(SOURCES)
	Rscript -e "library(exams);set.seed(666);exams2pdf(c('question1.Rmd', 'questionwithRcode.Rmd', 'questionwithPythonCode.Rmd'), dir='.',name='quiz', template='bio97')"

quiz1_solutions.pdf: $(SOURCES)
	Rscript -e "library(exams);set.seed(666);exams2pdf(c('question1.Rmd', 'questionwithRcode.Rmd', 'questionwithPythonCode.Rmd'), dir='.',name='quiz_solutions')"

clean:
	rm -f quiz1.pdf *_solutions*.pdf
