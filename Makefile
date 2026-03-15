# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22
.PHONY: all clean docs

all: results/horse_pops_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_sd.csv \
	reports/qmd_example.html \
	reports/qmd_example.pdf



# generate figures and objects for report
results/horse_pops_plot_largest_sd.png results/horse_pops_plot.png results/horses_sd.csv: source/generate_figures.py
	python source/generate_figures.py --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# render quarto report in HTML and PDF
reports/qmd_example.html: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to html

reports/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf


docs: reports/qmd_example.html results
	mkdir -p docs
	touch docs/.nojekyll
	cp reports/qmd_example.html docs/index.html
	cp -r reports/qmd_example_files docs/
	cp -r results docs/
	sed -i.bak 's|\.\./results/|results/|g' docs/index.html && rm -f docs/index.html.bak

# clean
clean:
	rm -rf results
	rm -rf docs
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files
