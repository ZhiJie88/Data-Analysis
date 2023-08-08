import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

selected_files = []  # Store the selected file paths
selected_x_columns = []  # Store the selected x-columns
selected_y_columns = []  # Store the selected y-columns

def browse_files():
    file_paths = filedialog.askopenfilenames(filetypes=[("CSV Files", "*.csv")])
    selected_files.clear()
    file_listbox.delete(0, tk.END)
    for file_path in file_paths:
        selected_files.append(file_path)
        file_listbox.insert(tk.END, os.path.basename(file_path))
    update_column_selector()

def update_column_selector():
    listbox_x_columns.delete(0, tk.END)
    listbox_y_columns.delete(0, tk.END)
    if selected_files:
        try:
            df = pd.read_csv(selected_files[0].strip())
            columns = df.columns.tolist()
            for column in columns:
                listbox_x_columns.insert(tk.END, column.strip())
                listbox_y_columns.insert(tk.END, column.strip())
        except Exception as e:
            messagebox.showerror("Error", str(e))

def set_x_columns(event):
    global selected_x_columns
    widget = event.widget
    selected_x_columns = [widget.get(idx).strip() for idx in widget.curselection()]

def set_y_columns(event):
    global selected_y_columns
    widget = event.widget
    selected_y_columns = [widget.get(idx).strip() for idx in widget.curselection()]

def plot_data():
    try:
        if len(selected_x_columns) < 1:
            messagebox.showwarning("Invalid Selection", "Please select an x-column.")
            return
        if len(selected_y_columns) < 1:
            messagebox.showwarning("Invalid Selection", "Please select at least one y-column.")
            return

        plt.figure(figsize=(12, 6))  # Adjust the figure size if needed

        x_min = None
        x_max = None

        for file_path in selected_files:
            try:
                df = pd.read_csv(file_path.strip())
                
                df.dropna(subset=selected_x_columns + selected_y_columns, inplace=True)  # Remove rows with missing values in selected columns

                if x_min is None:
                    x_min = df[selected_x_columns].min().min()
                    x_max = df[selected_x_columns].max().max()
                else:
                    x_min = min(x_min, df[selected_x_columns].min().min())
                    x_max = max(x_max, df[selected_x_columns].max().max())

                for y_col in selected_y_columns:
                    plt.plot(df[selected_x_columns[0]], df[y_col], 'o', markersize=2, label=os.path.basename(file_path))

            except pd.errors.ParserError as pe:
                messagebox.showwarning("Invalid Data", f"Skipped {os.path.basename(file_path)}: {str(pe)}")
                continue

        plt.xlabel(selected_x_columns[0])
        plt.ylabel(', '.join(selected_y_columns))
        plt.title('Data from CSV Files')
        plt.legend()

        plt.tight_layout()  # Adjust the spacing of the plot

        # Set x-axis tick size
        if x_max <= 500:
            x_ticks = np.arange(0, x_max+10, 10)
        elif x_max <= 1000:
            x_ticks = np.arange(0, x_max+100, 100)
        elif x_max <= 10000:
            x_ticks = np.arange(0, x_max+500, 500)
        else:
            x_ticks = np.arange(0, x_max+1000, 1000)

        plt.xticks(x_ticks, rotation=45)  # Rotate x-axis labels by 45 degrees

        plt.show()
    except Exception as e:
        messagebox.showerror("Error", str(e))

# Create the main window
window = tk.Tk()
window.title("CSV File Plotter")
window.geometry("410x550")  # Set the initial size of the window

# Create the file label
label_files = tk.Label(window, text="CSV Files:")
label_files.grid(row=0, column=1, padx=5, pady=5, sticky="w")

# Create the file listbox
file_listbox = tk.Listbox(window, selectmode=tk.MULTIPLE)
file_listbox.grid(row=1, column=1, padx=5, pady=5)

# Create the "Browse" button
btn_browse = tk.Button(window, text="Browse", command=browse_files)
btn_browse.grid(row=2, column=1, padx=5, pady=5)

# Create the "X Column Selection" label
label_x_columns = tk.Label(window, text="X Columns:")
label_x_columns.grid(row=3, column=0, padx=5, pady=5, sticky="w")

# Create the "X Columns" listbox
listbox_x_columns = tk.Listbox(window, selectmode=tk.MULTIPLE, exportselection=0)
listbox_x_columns.grid(row=4, column=0, padx=5, pady=5)
listbox_x_columns.bind("<<ListboxSelect>>", set_x_columns)

# Create the "Y Column Selection" label
label_y_columns = tk.Label(window, text="Y Columns:")
label_y_columns.grid(row=3, column=2, padx=5, pady=5, sticky="w")

# Create the "Y Columns" listbox
listbox_y_columns = tk.Listbox(window, selectmode=tk.MULTIPLE, exportselection=0)
listbox_y_columns.grid(row=4, column=2, padx=5, pady=5)
listbox_y_columns.bind("<<ListboxSelect>>", set_y_columns)

# Create the "Plot" button
btn_plot = tk.Button(window, text="Plot", command=plot_data)
btn_plot.grid(row=7, column=1, padx=5, pady=5)

# Start the GUI event loop
window.mainloop()
