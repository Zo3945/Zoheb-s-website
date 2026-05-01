import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Experience from './components/Experience';
import Skills from './components/Skills';
import Projects from './components/Projects';
import GitHubRepos from './components/GitHubRepos';
import Contact from './components/Contact';
import Footer from './components/Footer';
import ParticleBackground from './components/ParticleBackground';
import './styles/App.css';

function App() {
  const [searchQuery, setSearchQuery] = useState('');
  return (
    <div className="app">
      <ParticleBackground />
      <Navbar onSearch={setSearchQuery} />
      <main style={{ position: 'relative', zIndex: 1 }}>
        <Hero searchQuery={searchQuery} />
        <About searchQuery={searchQuery} />
        <Experience searchQuery={searchQuery} />
        <Skills searchQuery={searchQuery} />
        <Projects searchQuery={searchQuery} />
        <GitHubRepos searchQuery={searchQuery} />
        <Contact searchQuery={searchQuery} />
      </main>
      <Footer />
    </div>
  );
}
export default App;
