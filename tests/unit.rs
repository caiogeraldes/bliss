use bliss::*;

async fn setup() -> Bliss {
    Bliss::new().await
}

#[tokio::test]
/// Download supported_languages from the web
async fn web_supported_languages() {
    let bliss = setup().await;

    let result = bliss.supported_langs().await;
}

#[tokio::test]
/// Test pulling get_lang_gitignore with the rust language
async fn web_gitignore_rust() {
    let mut bliss = setup().await;

    let result = bliss.get_lang_gitignore("rust").await;

    let sucess = match result {
        None => false,
        Some(_) => true,
    };

    assert!(sucess);
}
