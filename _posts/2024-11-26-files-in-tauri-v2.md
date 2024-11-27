---
layout: post
mathjax: true
title:  "File Management in Tauri 2.0 with Rust"
description: "If you are just getting started with Tauri 2.0, opening, modifying, and saving files can seem quite a bit tricky. If you choose to use Rust rather than using the API provided by Tauri and struggle to get it working, this post is for you. Let's make a simple text file editor."
date:   2024-11-26 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["software"]
tag_search: true
image:     "/images/tauri_editor.png"
weight:
note: 
categories: "blog"
---

Tauri 2.0[^Tauri2] is a big step forward for the framework. It is a big step forward for Rust as well. But if you are just getting started with it, you might find that the documentation is not quite as thorough as you would like it to be and none of the current AI's have learned yet how to use it making them useless if not a hindrance!

So, when you are just getting started, opening, modifying, and saving files can seem quite a bit tricky. If you choose to use Rust rather than using the API provided by Tauri and struggle to get it working, this post is for you. Let's make a simple text file editor (which I lovingly called _fedit_ short for _"fucking edit!"_ in my angry desperation to get this working) like this:

![](/images/tauri_editor.png)

## Setup
Clone the repository and navigate into the project folder:
```bash
git clone https://github.com/QuentinWach/fedit
cd fedit
```
Then run the app with:
```bash
npm run tauri dev
```

You should see a window popping up just like in the image above. You can open a text file by clicking on the _Open_ button and then selecting a file using the system dialog window that will pop up as well as save the file by clicking on the _Save_ button which will open another dialog window asking you to specify the file name and directory. Modifications can be done in the text editor window.

## User Interface & Components
The UI here is created with React components[^React] you'll find in the `components/` folder. The Editor component returns the following:

```jsx
<div className="editor-container">
    <div className="button-container">
        <button onClick={handleOpen}>Open</button>
        <button onClick={handleSave}>Save</button>
    </div>
    <textarea
        className="editor-textarea"
        value={content}
        onChange={handleContentChange}
        placeholder="Type your text here..."
    />
</div>
```
You can see, it really is just the two mentioned buttons and a textarea below. But when clicking the buttons, the `handleOpen` and `handleSave` functions are called. Let's look at `handleOpen` as an example to understand how this works:

```jsx
const handleOpen = async () => {
    try {
        // Open a file selection dialog
        const selected = await open({
            multiple: false,
            filters: [{
                name: 'Text',
                extensions: ['md', 'txt']
            }]
        });
        
        if (selected) {
            // Read the file content using our Rust command
            const fileContent = await invoke('open_file', {
                path: selected
            });
            setContent(fileContent);
            console.log('File opened successfully!');
        }
    } catch (error) {
        console.error('Error opening file:', error);
    }
};
```
We use the `open` function to open a file selection dialog window to search for text files. This function (together with the `save` function) is provided by the `api` package which we import at the beginning of the `.jsx`-file with:
```jsx
import { open, save } from '@tauri-apps/plugin-dialog';
```
Next, we feed the selected file path to the `invoke` function which is used to call the `open_file` Rust function. To be able to use the `invoke` function, we need to import at the beginning of the file like this:
```jsx
import { invoke } from "@tauri-apps/api/core";
```

## Rust Functions
Using `invoke` we can call Rust[^Rust] functions from our JavaScript code. To do so, we need to declare the function in our `main.rs` file:
```rust
#[tauri::command]
fn open_file(path: String) -> Result<String, String> {
    fs::read_to_string(PathBuf::from(path))
        .map_err(|e| e.to_string())
}
```
The first line `#[tauri::command]` is used to declare the function as a Tauri command. This is necessary for the `invoke` function to be able to call it from JavaScript. The function then takes the path of the directory as a `String` as an argument and returns a `Result<String, String>` which is a common Rust pattern for returning a value or an error.

For this, we import the `fs` module to be able to read the file content and the `PathBuf` struct to be able to handle the path as a `PathBuf` object.
```rust
use std::fs;
use std::path::PathBuf;
```

We then make sure that we can call the `open_file` (and `save_file`) function from JavaScript and initialize the dialog plugin by adding the following lines to the `build` function in the `main.rs` file:
```rust
.invoke_handler(tauri::generate_handler![save_file, open_file])
.plugin(tauri_plugin_dialog::init())
```

## Configuration
Lastly, and importantly, we need to make sure that we list the capabilities we want to use in our `tauri.conf.json` file:
```json
"security": {
    "csp": null,
    "capabilities": []
}
```
We just need to add the empty `capabilities` list to the `security` section to get it to work. If you don’t include it, Tauri’s security model may restrict access to core APIs like file system operations. This is because the absence implies a configuration omission, and Tauri errs on the side of caution. This is meant to prevent malicious code from accessing your system through your application but also part of Tauri's philosophy of being aware of what your application is doing specifically.

We also need to add
```json
"withGlobalTauri": true
```
to actually enable global Tauri API access in the JavaScript code.

## Conclusion
With that, you should be able to open, edit, and save text files in your Tauri application.

One might compare this setup to how easy it is creating and modifying files using Python and wonder why we bother with Rust and all the hassle. But of course Python does not have the same security, it is absurdly slow, it is quite difficult to create beautiful and complex GUIs with Python which also easily compile into cross-platform executables.

So I hope this helped and if you have any questions or suggestions, feel free to leave a comment below. 😊


[^Tauri2]: [Tauri 2.0 Documentation](https://v2.tauri.app/start/)
[^React]: [React Documentation](https://react.dev/)
[^Rust]: [Rust Documentation](https://www.rust-lang.org/)