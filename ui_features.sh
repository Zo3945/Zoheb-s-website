#!/bin/bash

# ── 1. Animated hover cards (glow + lift effect) ─────────────────
cat >> src/components/Projects.css << 'EOF'

/* Animated hover cards */
.project-card {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease, border-color 0.3s ease;
}

.project-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 60px rgba(124, 106, 255, 0.25), 0 0 0 1px rgba(124, 106, 255, 0.3);
  border-color: rgba(124, 106, 255, 0.5);
}

.project-card:hover .project-card__title {
  color: var(--accent);
  transition: color 0.2s ease;
}

.project-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: var(--radius-lg);
  background: linear-gradient(135deg, rgba(124,106,255,0.05), transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.project-card:hover::after {
  opacity: 1;
}
EOF

# ── 2. Read more/less expanders on project cards ──────────────────
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Women in Cybersecurity Website',
    description: 'Designed and developed a responsive website for the WiCyS chapter at Pace University using HTML, CSS, and JavaScript.',
    fullDescription: 'Designed and developed a fully responsive website for the Women in Cybersecurity (WiCyS) chapter at Pace University. Built with HTML, CSS, and JavaScript, the site features event listings, member spotlights, and resource pages. The project won the Best Website Award at the Women in Cybersecurity competition, recognized for its clean design and accessibility.',
    tags: ['HTML', 'CSS', 'JavaScript'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: '🏆 Best Website Award',
  },
  {
    title: 'Snakes & Ladders',
    description: 'A fully interactive Snakes and Ladders board game built in Kotlin using Jetpack Compose.',
    fullDescription: 'Designed and developed a fully interactive Snakes and Ladders board game using Kotlin and Jetpack Compose for Android. Features include dynamic board generation, support for multiple players on a single device, animated piece movement, and complete game logic including win detection. Built with a clean Material Design UI.',
    tags: ['Kotlin', 'Jetpack Compose', 'Android'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: null,
  },
  {
    title: 'Driving Game',
    description: 'An interactive driving game where players control a vehicle and avoid dynamic obstacles.',
    fullDescription: 'Built an interactive driving game for Android where players control a vehicle navigating through dynamically generated obstacles. Implemented real-time collision detection, progressive difficulty scaling, score tracking with local high scores, and responsive touch controls. The physics-based movement system creates a realistic driving feel.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Spotify Playlist Analyzer',
    description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits.',
    fullDescription: 'A Python tool that connects to the Spotify Web API to analyze playlist data and surface insights about a user\'s listening habits. Features include top genre analysis, audio feature breakdowns (energy, danceability, valence), listening pattern trends, and exportable reports. Uses OAuth 2.0 for Spotify authentication.',
    tags: ['Python', 'API', 'Data'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Android Calendar App',
    description: 'A calendar-style Android app with event scheduling and a clean material design interface.',
    fullDescription: 'A full-featured calendar application for Android built in Java. Users can create, edit, and delete events with custom reminders, set recurring events, and view their schedule in day, week, or month views. Features a clean Material Design interface with smooth animations and local data persistence.',
    tags: ['Java', 'Android', 'Android Studio'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Candy Crush–Style Game',
    description: 'A match-3 puzzle game for Android inspired by Candy Crush, featuring animations and score tracking.',
    fullDescription: 'A match-3 puzzle game for Android inspired by Candy Crush. Built with Java and the Android SDK, the game features a fully animated tile-matching engine, combo detection, score multipliers, level progression, and satisfying particle effects when matches are made. Includes sound effects and a persistent high score system.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

// Read more/less expander component
function ProjectCard({ title, description, fullDescription, tags, github, live, featured, award, index, visible }) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div className={`project-card ${featured ? 'project-card--featured' : ''}`}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(40px)',
        transition: `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`
      }}>
      {featured && <span className="project-card__badge">Featured</span>}
      <h3 className="project-card__title">{title}</h3>
      {award && <p className="project-card__award">{award}</p>}
      <p className="project-card__desc">
        {expanded ? fullDescription : description}
      </p>
      <button
        className="project-card__expand"
        onClick={() => setExpanded(!expanded)}>
        {expanded ? '↑ Show less' : '↓ Read more'}
      </button>
      <div className="project-card__tags">
        {tags.map(t => <span key={t} className="project-card__tag">{t}</span>)}
      </div>
      <div className="project-card__actions">
        {github && <Button href={github} variant="ghost" external>GitHub</Button>}
        {live && <Button href={live} variant="outline" external>Live Demo</Button>}
      </div>
    </div>
  );
}

function Projects() {
  const [active, setActive] = useState('All');
  const [ref, visible] = useScrollAnimation(0.05);
  const filtered = active === 'All' ? PROJECTS : PROJECTS.filter(p => p.tags.some(t => t === active));

  return (
    <section id="projects" className="projects">
      <div className="container">
        <p className="section-label">Projects</p>
        <h2 className="section-title">Things I've Built</h2>
        <p className="section-subtitle">A selection of projects I'm proud of.</p>
        <div className="projects__filters">
          {FILTERS.map(f => (
            <button key={f} className={`projects__filter ${active === f ? 'projects__filter--active' : ''}`}
              onClick={() => setActive(f)}>{f}</button>
          ))}
        </div>
        <div className="projects__grid" ref={ref}>
          {filtered.map((p, i) => <ProjectCard key={p.title} {...p} index={i} visible={visible} />)}
        </div>
      </div>
    </section>
  );
}
export default Projects;
EOF

# Add expand button styles to Projects.css
cat >> src/components/Projects.css << 'EOF'

/* Read more/less button */
.project-card__expand {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--accent);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: opacity 0.2s ease;
  margin-top: -0.25rem;
}

.project-card__expand:hover {
  opacity: 0.7;
}
EOF

# ── 3. Easter egg — clicking name triggers a space explosion ──────
cat > src/components/EasterEgg.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';

function EasterEgg({ trigger }) {
  const canvasRef = useRef(null);
  const [show, setShow] = useState(false);

  useEffect(() => {
    if (!trigger) return;
    setShow(true);

    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = Array.from({ length: 120 }, (_, i) => ({
      x: canvas.width / 2,
      y: canvas.height / 2,
      angle: (i / 120) * Math.PI * 2,
      speed: Math.random() * 8 + 2,
      radius: Math.random() * 4 + 1,
      color: ['#7c6aff', '#57f0b0', '#a78bfa', '#ffffff', '#fbbf24'][Math.floor(Math.random() * 5)],
      life: 1,
      decay: Math.random() * 0.02 + 0.015,
    }));

    let animId;
    const draw = () => {
      ctx.fillStyle = 'rgba(4,4,13,0.15)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      let alive = false;
      particles.forEach(p => {
        p.x += Math.cos(p.angle) * p.speed;
        p.y += Math.sin(p.angle) * p.speed;
        p.speed *= 0.97;
        p.life -= p.decay;

        if (p.life > 0) {
          alive = true;
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
          ctx.fillStyle = p.color;
          ctx.globalAlpha = p.life;
          ctx.fill();
          ctx.globalAlpha = 1;
        }
      });

      if (alive) {
        animId = requestAnimationFrame(draw);
      } else {
        setShow(false);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
      }
    };

    draw();
    return () => cancelAnimationFrame(animId);
  }, [trigger]);

  if (!show) return null;

  return (
    <canvas ref={canvasRef} style={{
      position: 'fixed', inset: 0,
      width: '100%', height: '100%',
      pointerEvents: 'none',
      zIndex: 9999,
    }} />
  );
}

export default EasterEgg;
EOF

# Update Navbar to include easter egg on name click
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect } from 'react';
import EasterEgg from './EasterEgg';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about',      href: '#about' },
  { label: 'experience', href: '#experience' },
  { label: 'skills',     href: '#skills' },
  { label: 'projects',   href: '#projects' },
  { label: 'contact',    href: '#contact' },
];

function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);

  useEffect(() => {
    const onScroll = () => {
      setScrolled(window.scrollY > 40);
      const sections = NAV_LINKS.map(l => l.href.replace('#', ''));
      for (let i = sections.length - 1; i >= 0; i--) {
        const el = document.getElementById(sections[i]);
        if (el && window.scrollY >= el.offsetTop - 120) {
          setActive('#' + sections[i]);
          break;
        }
      }
    };
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleClick = (href) => {
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleLogoClick = () => {
    setEggTrigger(prev => prev + 1);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick}>
            Zoheb Khan
          </button>
          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={() => handleClick(link.href)}>
                {link.label}
              </button>
            ))}
            <a href="/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              resume ↓
            </a>
          </nav>
          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={() => setMenuOpen(!menuOpen)} aria-label="Toggle menu">
            <span /><span /><span />
          </button>
        </div>
      </header>
    </>
  );
}
export default Navbar;
EOF

echo "✅ All 3 UI features added!"
echo "  1. Animated hover cards — lift + glow effect on project cards"
echo "  2. Read more/less expanders — click to expand full project descriptions"
echo "  3. Easter egg — click your name in the navbar for a space explosion!"
